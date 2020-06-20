import look_up
import decode.{decode_dynamic}
import gleam/should
import gleam/result
import gleam/jsone
import look_up.{IssPassTime, IssPassTimeReponse}

pub fn decode_json_test() {
  let iss_pass_json = "
{
  \"message\": \"success\", 
  \"request\": {
    \"altitude\": 100, 
    \"datetime\": 1590654251, 
    \"latitude\": 53.0, 
    \"longitude\": 14.20, 
    \"passes\": 1
  }, 
  \"response\": [
    {
      \"duration\": 20, 
      \"risetime\": 1590677059
    }
  ]
}
    "
  look_up.decode_json(iss_pass_json)
  |> should.equal(
    Ok(
      IssPassTime(
        response: [IssPassTimeReponse(duration: 20, risetime: 1590677059)],
      ),
    ),
  )
}

pub fn decode_json_fails_if_missing_risetime_test() {
  let iss_pass_json = "
{
  \"message\": \"success\", 
  \"request\": {
    \"altitude\": 100, 
    \"datetime\": 1590654251, 
    \"latitude\": 53.0, 
    \"longitude\": 14.20, 
    \"passes\": 1
  }, 
  \"response\": [
    {
      \"duration\": 20, 
    }
  ]
}
    "
  look_up.decode_json(iss_pass_json)
  |> should.equal(Error("Unable to decode JSON"))
}

pub fn decode_json_fails_if_missing_response_field_test() {
  let iss_pass_json = "
{
  \"message\": \"success\", 
  \"request\": {
    \"altitude\": 100, 
    \"datetime\": 1590654251, 
    \"latitude\": 53.0, 
    \"longitude\": 14.20, 
    \"passes\": 1
  } 
}
    "
  look_up.decode_json(iss_pass_json)
  |> should.equal(Error("Unable to decode JSON"))
}

pub fn decode_json_fails_if_response_field_is_not_list_test() {
  let iss_pass_json = "
{
  \"message\": \"success\", 
  \"request\": {
    \"altitude\": 100, 
    \"datetime\": 1590654251, 
    \"latitude\": 53.0, 
    \"longitude\": 14.20, 
    \"passes\": 1
  }, 
  \"response\":{
    \"duration\": 20, 
  }
}
    "
  look_up.decode_json(iss_pass_json)
  |> should.equal(Error("Unable to decode JSON"))
}

pub fn get_risetime_test() {
  let iss_pass = IssPassTime(
    response: [IssPassTimeReponse(duration: 20, risetime: 1590677059)],
  )

  look_up.get_risetime(iss_pass)
  |> should.equal(Ok(1590677059))
}

pub fn convert_timestamp_to_string_test() {
  let timestamp = 1590677059

  look_up.convert_unix_timestamp(timestamp)
  |> should.equal(Ok("2020-05-28 14:44 +00:00"))
}
