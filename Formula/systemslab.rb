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
    tag:      "v0.0.112",
    revision: "288c8921c110752fa620a1e98945d9298a4d35ce"
  license   :cannot_represent

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/systemslab-0.0.112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bf6779eb92a1f12e89d8b6dfd7dfc3c9ca38bc526eaf5bd75f6b1c0ff3bffe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "419913189b7695e303ce99259649dc19e50ffb464dd20b32114980328c88dd72"
    sha256 cellar: :any_skip_relocation, ventura:       "11b036dcc4aa0ec668cfe9c4ab11f954e4cd9fc58079e21ae2007d42b24a000c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc844a43fca8fde7f8214026f025ff32d8b80bfd5e6a7939b15319f46aed19b2"
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
