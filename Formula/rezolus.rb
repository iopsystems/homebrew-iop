# Brew formula for the SystemsLab CLI.

class Rezolus < Formula
  desc      "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage  "https://rezolus.com"
  url       "https://github.com/iopsystems/rezolus.git",
    tag:      "v5.1.0",
    revision: "946dbc675733bfd15050ca2d7dfa443033cbe912"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/iopsystems/homebrew-iop/releases/download/rezolus-5.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a58db887dcc65af1c06e334f5d5c0873aff6b3e4966d345a9682fccf499955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "237c83b97d5141361ec4535921ef42eac5f78742218867a60bf59aff11ce30f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "110069be51edde2f3ad21379749c2cb812a61b71cad1e62791811aa4b05fb67d"
    sha256 cellar: :any_skip_relocation, ventura:       "f4a0a598ea3a0a00c6fc4ac3a8467ec0d8098d5f6d379892788f2d5538855fb8"
  end

  depends_on "llvm" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
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
