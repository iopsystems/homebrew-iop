# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "18f97c5c8177fdede60a93f1222c8ffa1d8c73899450c0180bbfd867555ffbb8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.15.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "176ceb88e68e198c67b3806cc52cbeeeaba0c735b57db801d0d59e2fd66bb892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d75d4f68656cb8680c7f7627f1688345d6a2fb1b540d17a613e2bed89a52aa38"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = formula_opt_bin("llvm")/"clang"
    ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
