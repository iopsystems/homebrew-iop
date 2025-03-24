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
    tag:      "v0.0.124",
    revision: "b9809ef27e178e95a4a8b9f6d85d9002681de972"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f70c3ac0b62306b1826d035bf63ed280921cf33fdad1642bb7485493c04a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09284ff8a8a9e94c7bc28dc3d11a0443df147f100798b495217dea53eac00d36"
    sha256 cellar: :any_skip_relocation, ventura:       "a8512c3071958a90b98e12c5e0423b19246fba016f6053d533f7f034cfb7569a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92e4072fcfcb68c835fa944e753e8b09725adb70ac2859516c48ce0976eae2b"
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
