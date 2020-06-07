import gleam/httpc.{Text, Response, None}
import gleam/http.{Get}
import gleam/dynamic.{Dynamic}
import gleam/result
import gleam/int
import gleam/jsone
import decode.{decode_dynamic}

pub external type StdOutput

pub external fn print(String) -> StdOutput =
  "io" "fwrite"

pub external fn debug_print(anything) -> StdOutput =
  "erlang" "display"

pub type IssPassTime {
  IssPassTime(request: IssPassTimeRequest, response: List(IssPassTimeReponse))
}

pub type IssPassTimeRequest {
  IssPassTimeRequest(
    altitude: Int,
    datetime: Int,
    latitude: Float,
    longitude: Float,
    passes: Int,
  )
}

pub type IssPassTimeReponse {
  IssPassTimeReponse(duration: Int, risetime: Int)
}

pub fn api_call() -> StdOutput {
  let result = httpc.request(
    method: Get,
    url: "http://api.open-notify.org/iss-pass.json?lat=52.520008&lon=13.404954",
    headers: [tuple("accept", "application/vnd.hmrc.1.0+json")],
    body: None,
  )

  case result {
    Ok(response) -> print(response.body)
    Error(e) -> {
      debug_print(e)
      print("Error making request:(\n")
    }
  }
}

pub fn decode_json(iss_pass_json: String) -> Result(IssPassTime, String) {
  let iss_pass_time_request_decoder = decode.map5(
    IssPassTimeRequest,
    decode.field("altitude", decode.int()),
    decode.field("datetime", decode.int()),
    decode.field("latitude", decode.float()),
    decode.field("longitude", decode.float()),
    decode.field("passes", decode.int()),
  )

  let iss_pass_time_response_decoder = decode.map2(
    IssPassTimeReponse,
    decode.field("duration", decode.int()),
    decode.field("risetime", decode.int()),
  )

  let result_decoder = decode.map2(
    IssPassTime,
    decode.field("request", iss_pass_time_request_decoder),
    decode.field("response", decode.list(iss_pass_time_response_decoder)),
  )

  let dynamic_object_result = iss_pass_json
    |> jsone.decode
    |> result.then(decode_dynamic(_, result_decoder))

  case dynamic_object_result {
    Ok(_) -> dynamic_object_result
    _ -> Error("Couldn't decode JSON into IssPassTimes.")
  }
}
