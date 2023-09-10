setup() {
  load 'test_helper/common-setup'
  _common_setup

  source functions_lib.sh
}

teardown() {
  : # rm -f /tmp/bats-tutorial-project-ran
}

@test "gen_search_str" {
  run gen_search_str ""
  assert_output ""

  run gen_search_str "a"
  assert_output "a"
  
  run gen_search_str " a"
  assert_output "%20a"

  run gen_search_str "a "
  assert_output "a%20"

  run gen_search_str " a "
  assert_output "%20a%20"

  run gen_search_str "\""
  assert_output "%22"

  run gen_search_str "*"
  assert_output "%2A"

  # run gen_search_str "-"
  # assert_output "-"

  run gen_search_str "_"
  assert_output "_"

  run gen_search_str "~"
  assert_output "~"

  run gen_search_str "<"
  assert_output "%3C"

  run gen_search_str ">"
  assert_output "%3E"

  run gen_search_str "."
  assert_output "."

  run gen_search_str "+"
  assert_output "%2B"

  run gen_search_str "'"
  assert_output "%27"

  run gen_search_str "?"
  assert_output "%3F"

  run gen_search_str "!"
  assert_output "%21"

  run gen_search_str "@"
  assert_output "%40"

  run gen_search_str "#"
  assert_output "%23"

  run gen_search_str "$"
  assert_output "%24"

  run gen_search_str "%"
  assert_output "%25"

  run gen_search_str "^"
  assert_output "%5E"

  run gen_search_str "&"
  assert_output "%26"

  run gen_search_str "("
  assert_output "%28"

  run gen_search_str ")"
  assert_output "%29"

  run gen_search_str "="
  assert_output "%3D"

  run gen_search_str "{"
  assert_output "%7B"

  run gen_search_str "}"
  assert_output "%7D"

  run gen_search_str "["
  assert_output "%5B"

  run gen_search_str "]"
  assert_output "%5D"

  run gen_search_str "\`"
  assert_output "%60"

  run gen_search_str "|"
  assert_output "%7C"

  run gen_search_str "\\"
  assert_output "%5C"

  run gen_search_str ":"
  assert_output "%3A"

  run gen_search_str ";"
  assert_output "%3B"

  run gen_search_str ","
  assert_output "%2C"
}

