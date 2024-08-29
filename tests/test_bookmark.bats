setup() {
  load 'test_helper/common-setup'
  _common_setup

  source "$PROJECT_ROOT"/src/functions_lib.sh
}

teardown() {
  : # rm -f /tmp/bats-tutorial-project-ran
}

@test "get_title_list with one normal title" {
  run get_title_list tests/bookmarks_one_normal.yaml

  assert_output "Real-time"
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
double \"quote\" single' Webpage
gmail account for evoagile"
}

@test "find_url_by_title for normal title 1" {
  run find_url_by_title "Home | Gilles Castel" tests/bookmarks_multiple.yaml
  assert_output "https://castel.dev"
}

@test "find_url_by_title for normal title 2" {
  run find_url_by_title "jdpedersen1 (Jake@Linux)" \
    tests/bookmarks_multiple.yaml
  assert_output "https://github.com/jdpedersen1"
}

@test "find_url_by_title for double quote title" {
  run find_url_by_title "Real-time \\\"LaTeX\\\" engine" \
    tests/bookmarks_one_double_quote.yaml

  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro"
}

@test "find_rul_by_title for single quote title" {
  run find_url_by_title "What's most important thing" \
    tests/bookmarks_one_single_quote.yaml
  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro"
}

@test "find_url_by_title for one single and double quote title" {
  run find_url_by_title "You're the only one, last \\\"forever\\\"." \
    tests/bookmarks_one_single_double_quote.yaml

  assert_output "https://www.ejmastnak.com/tutorials/vim-latex/intro"
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
  assert_output "cmd
double quote
github
jake
linux
luke
note taking
pass
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

@test "get_num_of_items for title" {
  run get_num_of_items ""
  assert_output "0"

  run get_num_of_items "item 1"
  assert_output "1"

  run get_num_of_items "item 1
  item 2"
  assert_output "2"

  run get_num_of_items "item 1
item 2
item 3
item 4
item 5"
  assert_output "5"
}

@test "get_num_url" {
  run get_num_url "https://castel.dev" tests/bookmarks_multiple.yaml
  assert_output "1"

  run get_num_url "https://doublesinglequote.com/" \
    tests/bookmarks_multiple.yaml
  assert_output "0"

  run get_num_url "https://doublesinglequote.com" tests/bookmarks_multiple.yaml
  assert_output "1"

  run get_num_url "https://non.exist.url/" tests/bookmarks_multiple.yaml
  assert_output "0"
}

@test "rm_tail_slash" {
  run rm_tail_slash ""
  assert_output ""

  run rm_tail_slash "/"
  assert_output ""

  run rm_tail_slash "https://castel.dev"
  assert_output "https://castel.dev"

  run rm_tail_slash "https://castel.dev/"
  assert_output "https://castel.dev"
}

@test "get_num_title" {
  run get_num_title "" tests/bookmarks_multiple.yaml
  assert_output "0"

  run get_num_title "Home | Gilles Castel" tests/bookmarks_multiple.yaml
  assert_output "1"

  run get_num_title "No exist title" tests/bookmarks_multiple.yaml
  assert_output "0"
}

@test "to_lowercase" {
  run to_lowercase ""
  assert_output ""

  run to_lowercase "TAGS"
  assert_output "tags"

  run to_lowercase "TaGs"
  assert_output "tags"

  run to_lowercase "TagS"
  assert_output "tags"

  run to_lowercase "Real-time \\\"LaTeX\\\" engine"
  assert_output "real-time \\\"latex\\\" engine"

  run to_lowercase "Tag_A, Tag_B, Tag_C"
  assert_output "tag_a, tag_b, tag_c"
}

@test "trim" {
  run trim ""
  assert_output ""

  run trim " a"
  assert_output "a"

  run trim "a "
  assert_output "a"

  run trim "  a"
  assert_output "a"

  run trim "a  "
  assert_output "a"

  run trim "  a  "
  assert_output "a"

  run trim "  ab  "
  assert_output "ab"

  run trim "  a b  "
  assert_output "a b"

  run trim "  a  b  "
  assert_output "a  b"
}

@test "gen_tags_str" {
  run gen_tags_str ""
  assert_output ""

  run gen_tags_str "a"
  assert_output "\"a\""

  run gen_tags_str " a"
  assert_output "\"a\""

  run gen_tags_str ", a"
  assert_output "\"a\""

  run gen_tags_str " , a"
  assert_output "\"a\""

  run gen_tags_str "a,"
  assert_output "\"a\""

  run gen_tags_str "a, "
  assert_output "\"a\""

  run gen_tags_str "a b"
  assert_output "\"a b\""

  run gen_tags_str "a, b"
  assert_output "\"a\", \"b\""

  run gen_tags_str "a, b, c"
  assert_output "\"a\", \"b\", \"c\""

  run gen_tags_str "a , b , c "
  assert_output "\"a\", \"b\", \"c\""

  run gen_tags_str "a , b & c, d"
  assert_output "\"a\", \"b & c\", \"d\""

  run gen_tags_str "a tag, b & c tag, d tag,"
  assert_output "\"a tag\", \"b & c tag\", \"d tag\""
}

@test "add_new_entry" {
  run add_new_entry "https://url" "title" "\"tag\"" tests/null_bookmarks.yaml
  assert_output "url: https://url
title: title
tags:
  - tag"

  run add_new_entry "https://url" "title" "\"tag1\", \"tag2\"" \
    tests/null_bookmarks.yaml
  assert_output "url: https://url
title: title
tags:
  - tag1
  - tag2"

  run add_new_entry "https://url" "title" "\"tag\"" \
    tests/bookmarks_one_normal.yaml
  assert_output "- url: https://vim-latex
  title: Real-time
  tags:
    - tex
- url: https://url
  title: title
  tags:
    - tag"
}

@test "check_cmd_type" {
  run check_tag "Home | Gilles Castel" "cmd" tests/bookmarks_multiple.yaml
  assert_output "no"

  run check_tag "Home | Gilles Castel" "tex" tests/bookmarks_multiple.yaml
  assert_output "yes"

  run check_tag "Home | Gilles Castel" "note taking" \
    tests/bookmarks_multiple.yaml
  assert_output "yes"

  run check_tag "gmail account for evoagile" "cmd" \
    tests/bookmarks_multiple.yaml
  assert_output "yes"

  run check_tag "gmail account for evoagile" "pass" \
    tests/bookmarks_multiple.yaml
  assert_output "yes"

  run check_tag "gmail account for evoagile" "wrong tag" \
    tests/bookmarks_multiple.yaml
  assert_output "no"
}
