# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.93",
    revision: "e8bb14cbc96a09a3dd3caacba9e90b89ed085e23"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.93"
    sha256 cellar: :any,                 arm64_ventura: "d1d7bb730ec33e21e32d26b9562ce2e685a2c861dd60913c64cff7bbb7fe8aa9"
    sha256 cellar: :any,                 ventura:       "8a279f11fd8f486381b043da526fecbebb214a129c86fcb7f630ab45fb10f254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd1b095b5c8ed170fbfdaf512bb7fc064ab90a7cbce1d11dd65fd5933d04f1e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "bzip2"
  depends_on "openssl@3"
  depends_on "xz"

  def install
    system "cargo", "install",
      "--bin", "systemslab",
      "--path", "crates/cli",
      "--profile", "prod",
      "--locked",
      "--root", prefix

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
  end

  test do
    content = <<-EOM
      local systemslab = import "systemslab.libsonnet";

      {
        name: 'test experiment',
        jobs: {
          test_job: {
            steps: [
              systemslab.bash('true')
            ]
          }
        }
      }
    EOM

    File.write("test.jsonnet", content)

    system "#{bin}/systemslab", "evaluate", "test.jsonnet"
  end
end
