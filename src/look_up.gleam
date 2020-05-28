import gleam/httpc.{Text, Response, None}
import gleam/http.{Get}

pub external type StdOutput

pub external fn print(String) -> StdOutput =
  "io" "fwrite"

pub external fn debug_print(anything) -> StdOutput =
  "erlang" "display"

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
