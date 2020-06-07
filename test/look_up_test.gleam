import look_up
import decode.{decode_dynamic}
import gleam/should
import gleam/result
import gleam/jsone
import look_up.{IssPassTime, IssPassTimeRequest, IssPassTimeReponse}

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
        request: IssPassTimeRequest(
          altitude: 100,
          datetime: 1590654251,
          latitude: 53.0,
          longitude: 14.20,
          passes: 1,
        ),
        response: [IssPassTimeReponse(duration: 20, risetime: 1590677059)],
      ),
    ),
  )
}
