load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

function cleanup {
  rm -rf test/integration/test_ide_work/{src,pkg,bin,output,vendor}
  rm -rf test/integration/test_ide_work_multiproj/{src,pkg,bin,output,vendor}
}


@test "cleanup" {
  cleanup
}
@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "ide init finished"
  assert_line --partial "/ide/work/src/github.com/notexistentuser/myproject"
  assert_line --partial "golang-ide"
  assert_line --partial "creating group: docker"
  refute_output --partial "root"
  assert_equal "$status" 0
}
@test "go is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "go version go1.11"
  assert_equal "$status" 0
}
@test "GOPATH is set" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go env | grep GOPATH\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "GOPATH=\"/ide/work\""
  assert_equal "$status" 0
}
@test "go install result can be created and is visible on docker host" {
  # go install the highest go executable command (cli),
  # it uses the go library package clock.
  # Notice that no external dependencies are needed to compile this package.
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"go install ./cli\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0

  # this is the compiled executable command file
  run test -f test/integration/test_ide_work/bin/cli
  assert_equal "$status" 0

  # this is the compiled library package file (was needed to build the cli command);
  # since go 1.10, this file is not persisted
  run test -f test/integration/test_ide_work/pkg/linux_amd64/github.com/notexistentuser/myproject/clock.a
  assert_equal "$status" 1
}
@test "go install result can be run" {
  # Again, no external dependencies are needed to run this package.
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"./bin/cli\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Clock is: 11:00"
  assert_equal "$status" 0
}
@test "ide user is added to group: docker" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"id\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "docker"
  assert_equal "$status" 0
}
@test "can talk to docker daemon using api (because socket is mounted)" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"curl --unix-socket /run/docker.sock http://localhost/containers/json\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "ImageID"
  assert_equal "$status" 0
}
@test "cleanup" {
  cleanup
}
@test "go test fails when dependencies are not installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"rm -rf vendor/ && go test -v ./clock\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "setup failed"
  refute_output --partial "PASS"
  assert_line --partial "FAIL"
  assert_equal "$status" 1
}
@test "go test works after dependencies installed with glide" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"rm -rf vendor/ && glide install && go test -v ./clock\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Fetching github.com"
  assert_line --partial "PASS"
  refute_output --partial "FAIL"
  assert_equal "$status" 0
}
@test "dep is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"dep version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "0.5.0"
  assert_equal "$status" 0
}

@test "cleanup" {
  cleanup
}
