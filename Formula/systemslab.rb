# Brew formula for the SystemsLab CLI.

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    tag:      "v0.0.74",
    revision: "482959bb49067eec2866f99629a07517459743af"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.74"
    sha256 cellar: :any,                 arm64_ventura: "c68903d013b49a76de3331d22624be46a2f8c607964bd0a1e19d44f96a894c4d"
    sha256 cellar: :any,                 ventura:       "cc645d3319db86a223231fbcb325a4a555bacff48b229e353a88e3cb84270197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46629fa0bf2917c1f28ab8b93081adb1514eec0dd6d64ed2f8d4cc3ee8991105"
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
