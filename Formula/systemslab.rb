# Brew formula for the SystemsLab CLI.

class SystemsLabDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Systemslab < Formula
  desc      "CLI for interacting with SystemsLab servers"
  homepage  "https://iop.systems"
  url       "https://github.com/iopsystems/systemslab.git",
    using:    SystemsLabDownloadStrategy,
    tag:      "v131.0.0",
    revision: "f539c53664abc79990451837b29b17b4c53a0302"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-131.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "e244a1605139dcb3b5a2f227f829759098407319b6bb783caaf107482467d531"
    sha256 cellar: :any,                 arm64_sonoma:  "49ad8d0fda0ddbab5962b4f966c4b5f01a0b14804816257cd7bc5f25af8627e3"
    sha256 cellar: :any,                 arm64_ventura: "64e1181c03269e9d5d852ee286f9a4f430f11f0dd75fa1da6ad1e1df66e5c8f9"
    sha256 cellar: :any,                 ventura:       "1f4963629cede24a412ce406f2ae02b089ab88e9fabddbdf27d1659cbf35f47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efd7e6f70fdedeb093120e253db38f65e5104f1a5f048416664a0f1f2bc8f6be"
  end

  depends_on "go" => :build
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

    system prefix/"bin"/"systemslab", "completions", "bash", "-o", "systemslab"
    system prefix/"bin"/"systemslab", "completions", "fish", "-o", "systemslab.fish"
    system prefix/"bin"/"systemslab", "completions", "zsh", "-o", "_systemslab"

    pkgshare.install "crates/cli/jsonnet/systemslab.libsonnet"
    bash_completion.install "systemslab"
    fish_completion.install "systemslab.fish"
    zsh_completion.install "_systemslab"
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
