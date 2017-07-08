load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "cleanup" {
  rm -rf test/integration/end_user/test_ide_work/src
  rm -rf test/integration/end_user/test_ide_work/pkg
  rm -rf test/integration/end_user/test_ide_work/bin
}
@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "ide init finished"
  assert_line --partial "/ide/work"
  assert_line --partial "golang-ide"
  refute_output "root"
  assert_equal "$status" 0
}
@test "go is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "go version go1.8"
  assert_equal "$status" 0
}
@test "GOPATH is set" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go env\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "GOPATH=\"/ide/work\""
  assert_equal "$status" 0
}
@test "Can build golang agent" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"git clone https://github.com/gocd-contrib/gocd-golang-agent.git src/github.com/gocd-contrib/gocd-golang-agent\""
  assert_equal "$status" 0
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go run src/github.com/gocd-contrib/gocd-golang-agent/build/build.go\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Building Binary"
  assert_equal "$status" 0
}
@test "cleanup" {
  rm -rf test/integration/end_user/test_ide_work/src
  rm -rf test/integration/end_user/test_ide_work/pkg
  rm -rf test/integration/end_user/test_ide_work/bin
}
