import gleam/httpc.{Text, Response, None}
import gleam/http.{Get}
import gleam/result
import gleam/int
import gleam/float
import gleam/list
import gleam/string
import gleam/jsone
import decode.{decode_dynamic}

pub external type StdOutput

pub external fn print(String) -> StdOutput =
  "io" "fwrite"

pub external fn timestamp_to_string(String, Int) -> String =
  "qdate" "to_string"

pub type IssPassTime {
  IssPassTime(response: List(IssPassTimeReponse))
}

pub type IssPassTimeReponse {
  IssPassTimeReponse(duration: Int, risetime: Int)
}

pub fn make_request(lat: String, long: String) -> Result(String, String) {
  let url = string.concat(
    ["http://api.open-notify.org/iss-pass.json?lat=", lat, "&lon=", long],
  )
  let result = httpc.request(
    method: Get,
    url: url,
    headers: [tuple("accept", "application/vnd.hmrc.1.0+json")],
    body: None,
  )

  case result {
    Ok(response) -> Ok(response.body)
    Error(e) -> Error("Error making request\n")
  }
}

pub fn decode_json(iss_pass_json: String) -> Result(IssPassTime, String) {
  let iss_pass_time_response_decoder = decode.map2(
    IssPassTimeReponse,
    decode.field("duration", decode.int()),
    decode.field("risetime", decode.int()),
  )

  let result_decoder = decode.map(
    IssPassTime,
    decode.field("response", decode.list(iss_pass_time_response_decoder)),
  )

  let dynamic_object_result = iss_pass_json
    |> jsone.decode
    |> result.then(decode_dynamic(_, result_decoder))

  case dynamic_object_result {
    Ok(_) -> dynamic_object_result
    _ -> Error("Unable to decode JSON")
  }
}

pub fn get_risetime(iss_pass: IssPassTime) -> Result(Int, String) {
  let response = iss_pass.response
    |> list.head

  case response {
    Ok(response) -> Ok(response.risetime)
    Error(e) -> Error("Error getting the risetime from the response")
  }
}

pub fn convert_unix_timestamp(timestamp: Int) -> Result(String, String) {
  let ts = timestamp_to_string("Y-m-d H:i P", timestamp)
  Ok(ts)
}

pub fn run(lat: Float, long: Float) -> StdOutput {
  let decoded = make_request(float.to_string(lat), float.to_string(long))
    |> result.then(decode_json(_))
    |> result.then(get_risetime(_))
    |> result.then(convert_unix_timestamp(_))

  case decoded {
    Ok(ts) -> {
      let message = string.concat(
        ["Look up at ", ts, " if you want to see the space station!\n"],
      )
      print(message)
    }
    _ -> print("uh oh - unable to determine when to look up :(\n")
  }
}
