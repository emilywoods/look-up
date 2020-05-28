import look_up
import gleam/should

pub fn hello_world_test() {
  look_up.hello_world()
  |> should.equal("Hello, from look_up!")
}
