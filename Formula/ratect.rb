class Ratect < Formula
  desc "The forward-looking Ratect CLI, free to diverge from Batect's interface"
  homepage "https://github.com/or1can/ratect"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.12.0/ratect-aarch64-apple-darwin.tar.xz"
      sha256 "0cdb5930447eae46e40722e7912ac27dea69e38cef7e8b6f2b76d862f7a3152c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.12.0/ratect-x86_64-apple-darwin.tar.xz"
      sha256 "a9c34451a15710f80a33661a68833923527a7e0ccb3146de97655898411a73af"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.12.0/ratect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "31636079b3fdd8880214733bb4354acf8f39453450ba91ac9b716ea181980945"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect/v0.12.0/ratect-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8af667a4401f52f7c19af996666f973747a9056c9b3f2a1e1436854c98887a75"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
