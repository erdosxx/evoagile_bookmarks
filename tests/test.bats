setup() {
  load '/usr/share/bats-support/load'
  load '/usr/share/bats-assert/load'
  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  # make executables in src/ visible to PATH
  PATH="$DIR/../src:$PATH"

  source functions_lib.sh
}

teardown() {
  : # rm -f /tmp/bats-tutorial-project-ran
}

@test "get_title_list with one normal title" {
  run get_title_list tests/bookmarks_one_normal.yaml

  assert_output "Real-time LaTeX using Vim/Neovim | ejmastnak"
}

@test "get_title_list with one double quote title" {
  run get_title_list tests/bookmarks_one_double_quote.yaml

  assert_output "Real-time \"LaTeX\" engine"
}

@test "get_title_list with one single quote title" {
  run get_title_list tests/bookmarks_one_single_quote.yaml

  assert_output "What's most important thing"
}

@test "get_title_list with one single and double quote title" {
  run get_title_list tests/bookmarks_one_single_double_quote.yaml

  assert_output "You're the only one, last \"forever\"."
}

@test "get_title_list with multiple titles" {
  run get_title_list tests/bookmarks_multiple.yaml

  assert_output "Home | Gilles Castel
Jake@Linux | Focused on Linux and F.O.S.S.
jdpedersen1 (Jake@Linux)
Luke's Webpage
double \"quote\" Webpage
double \"quote\" single' Webpage"
}

@test "find_url_by_title for normal title 1" {
  run find_url_by_title "Home | Gilles Castel" tests/bookmarks_multiple.yaml
  assert_output "https://castel.dev/"
}

@test "find_url_by_title for normal title 2" {
  run find_url_by_title "jdpedersen1 (Jake@Linux)" tests/bookmarks_multiple.yaml
  assert_output "https://github.com/jdpedersen1"
}

@test "find_url_by_title for double quote title" {
  run find_url_by_title "Real-time \\\"LaTeX\\\" engine" tests/bookmarks_one_double_quote.yaml

  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro/"
}

@test "find_rul_by_title for single quote title" {
  run find_url_by_title "What's most important thing" tests/bookmarks_one_single_quote.yaml
  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro/"
}

@test "find_url_by_title for one single and double quote title" {
  run find_url_by_title "You're the only one, last \\\"forever\\\"." tests/bookmarks_one_single_double_quote.yaml

  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro/"
}

@test "remove_head_tail_chars for normal \"string\"" {
  run remove_head_tail_chars "\"start"
  assert_output "start"

  run remove_head_tail_chars "start\""
  assert_output "start"

  run remove_head_tail_chars "\"start\""
  assert_output "start"

  run remove_head_tail_chars "\"sta\"rt\""
  assert_output "sta\"rt"
}

@test "remove_head_tail_chars for normal 'string'" {
  run remove_head_tail_chars "'start" "'"
  assert_output "start"

  run remove_head_tail_chars "start'" "'"
  assert_output "start"

  run remove_head_tail_chars "'start'" "'"
  assert_output "start"

  run remove_head_tail_chars "'sta'rt'" "'"
  assert_output "sta'rt"
}

@test "add_two_back_slashes in sting" {
  run add_two_back_slashes "without slash"
  assert_output "without slash"

  run add_two_back_slashes "one \" slash"
  assert_output "one \\\" slash"

  run add_two_back_slashes "two \"slash\""
  assert_output "two \\\"slash\\\""
}

@test "get_uniq_tags for normal bookmarks" {
  run get_uniq_tags tests/bookmarks_multiple.yaml
  assert_output "double quote
github
jake
linux
luke
note taking
single quote
tex
web site"
}

@test "get_title_list_by_tag for tags" {
  run get_title_list_by_tag "github" tests/bookmarks_multiple.yaml
  assert_output "jdpedersen1 (Jake@Linux)"

  run get_title_list_by_tag "single quote" tests/bookmarks_multiple.yaml
  assert_output "Luke's Webpage
double \"quote\" single' Webpage"

  run get_title_list_by_tag "double quote" tests/bookmarks_multiple.yaml
  assert_output "double \"quote\" Webpage
double \"quote\" single' Webpage"
}

# @test "Show welcome message on first invocation" {
#   [[ -e /tmp/bats-tutorial-project-ran ]] && skip 'The FIRST_RUN_FILE already exists'
#
#   run project.sh
#   assert_output --partial 'Welcome to our project!'
#
#   run project.sh
#   refute_output --partial 'Welcome to our project!'
# }
