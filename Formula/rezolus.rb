# Brew formula for the SystemsLab CLI.

class Rezolus < Formula
  desc      "High-resolution systems telemetry, including multiple recorders and a viewer"
  homepage  "https://rezolus.com"
  url       "https://github.com/iopsystems/rezolus.git",
    tag:      "v5.1.0",
    revision: "946dbc675733bfd15050ca2d7dfa443033cbe912"
  license any_of: ["Apache-2.0", "MIT"]

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
