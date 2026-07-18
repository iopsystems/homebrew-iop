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
    tag:      "v155.0.0",
    revision: "20eebbba5991a698442605b61aa97316a9997881"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-155.0.0"
    sha256 cellar: :any, arm64_sequoia: "23d25bf317bbb682299112cf47a56692f6a2a57e3bc8398d1d90a5443bfc715c"
    sha256 cellar: :any, arm64_sonoma:  "1e92064c2678aa0321616693a79329d56563064122372f088a7f005a00942222"
    sha256 cellar: :any, x86_64_linux:  "6a769e33172a336642f26059d1678439bafbc4377b2b46e1a844a2184c810c84"
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
