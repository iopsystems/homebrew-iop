# Brew formula for rezolus.

class Rezolus < Formula
  desc "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage "https://rezolus.com"
  url "https://github.com/iopsystems/rezolus/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "a959d91ceeca1d83f7067d09c8be26fd05ab94d46b9f90e8aad571580f2a82c8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.11.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b37c10a816e2da4852b8579075a89ae9a8c55a38191854d6dbf6b9746b69218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18034bbaf8f0601d3abb2dfa5a4f9a86a123b87a6f10bc324ff3f07deb22dd6c"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "libelf"
  depends_on "zlib"

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "rezolus", shell_output("#{bin}/rezolus --version")
  end
end
