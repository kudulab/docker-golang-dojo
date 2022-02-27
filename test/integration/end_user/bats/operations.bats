load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

function cleanup {
  rm -rf test/integration/test_dojo_work/{src,pkg,bin,output,vendor}
}

@test "cleanup before" {
  cleanup
}
@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "dojo init finished"
  assert_line --partial "/dojo/work"
  refute_output --partial "root"
  assert_equal "$status" 0
}
@test "go is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"go version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "go version go1.17"
  assert_equal "$status" 0
}
@test "GOPATH is set" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"go env | grep GOPATH\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "GOPATH=\"/home/dojo/go\""
  assert_equal "$status" 0
}
@test "a go executable can be compiled and run" {
  test_dir="test/integration/test_dojo_work/executable-no-dependencies"

  [ -d "${test_dir}/bin" ] && rm -rf "${test_dir}/bin"
  mkdir "${test_dir}/bin"
  run /bin/bash -c "dojo -c Dojofile.to_be_tested -work-dir-outer ${test_dir} \"go build -o bin/executable-no-dependencies\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0

  # run it in a docker container
  run /bin/bash -c "dojo -c Dojofile.to_be_tested -work-dir-outer ${test_dir} \"./bin/executable-no-dependencies\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Hello, world."
  assert_equal "$status" 0

  # run it locally
  run /bin/bash -c "${test_dir}/bin/executable-no-dependencies"
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Hello, world."
  assert_equal "$status" 0
}
@test "a go library can be tested after its dependencies are installed" {
  test_dir="test/integration/test_dojo_work/clock"

  run /bin/bash -c "dojo -c Dojofile.to_be_tested -work-dir-outer ${test_dir} \"go install && go test -v\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
  assert_line --partial "PASS: TestCompareClocks"
}


@test "cleanup after" {
  cleanup
}
