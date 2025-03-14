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
    tag:      "v0.0.121",
    revision: "71cfc3b7a2b1878410e3a62ba3e02e9cc878d4dd"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24642a1acd505d1a2141064c84b974dbb65f85c9e111722b865c69c89affd2ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6926b079f78936c8fe96dafe1aced5c635a5c245e4251e8f9a0435e69b0d415e"
    sha256 cellar: :any_skip_relocation, ventura:       "92d8788cca6f55d28a76e630fe6f485bb1456c303cbc7a533da78db0ae0d591f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6065854456a8cce13d213a4d6c3ae3c9a44ccdf831478c19bf050156a0a4b6"
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
