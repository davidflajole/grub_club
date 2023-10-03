# GrubClub FoodCarts Context Module and Tests

  Built on Elixir/Erlang:
    * Erlang/OTP 26 [erts-14.0.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns] [dtrace]
    * Elixir 1.15.6 (compiled with Erlang/OTP 26)

  Steps to run project:
    * Clone repo to working directory
    * cd into grub_club
    * Run `mix setup` to install and setup dependencies
    * Run mix test to see tests are passing
    * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
      > verify that project runs and standard phoenix bootstrapped page loads in browser (http://localhost:4000)

  
  ## About Grub Club:
 
    This is my first iteration of an interesting, but rather basic idea for a quick tech challenge. It was
    intended to be a simple take-home open-ended sandbox exercise using a small dataset of food trucks in the 
    San Francisco area. In my limited time available and only hoping to achieve a first pass, I decided on
    the following scope.
    * Import the data from the provided csv: https://github.com/davidflajole/grub_club/blob/main/assets/MFFP.csv
    * Replace zip codes with a mocked geolocation function providing San Francisco zip codes:
      https://github.com/davidflajole/grub_club/blob/main/assets/SanFranZips.csv
    * Limit fields of interest
    * Clean the data
    * Prefer atoms as keys
    * Provide a few filter functions to fuel future development
    * Achieve moderate test coverage.
    * Submit for paired review with zero credo suggestions
    


  ## Future Development

  * Add a LiveView page to view and filter food carts
  * Add a Phoenix API and create Postman calls
  * Refactor with LiveBook
  * Replace mock_geo_sf_zip with a free account reverse geo lookup
  * Create a Cart Struct
