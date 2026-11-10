class RatectCompat < Formula
  desc "A strict, flag-for-flag and field-for-field drop-in replacement for the (now-unmaintained) batect binary"
  homepage "https://github.com/or1can/ratect"
  version "0.34.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.34.0/ratect-compat-aarch64-apple-darwin.tar.xz"
      sha256 "d4ebaff3a6dbedb6d84e5ab97a245078b9b3723ecdc7e76a9ff2d510bc08e5be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.34.0/ratect-compat-x86_64-apple-darwin.tar.xz"
      sha256 "5961d3b591d7e0cb23ba97da0a6a942826e0d27a178f9b6cd15a86d47895e406"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.34.0/ratect-compat-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e2fa75b9fc6539768d09690cc612a22e12da949ca86e230bf8e70f15f9ed3f20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.34.0/ratect-compat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "679fc310b244bc4afa78eb71e0c1ef660ba268e27eafdb04fbb9d5861a3cd467"
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
      bin.install "ratect-compat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ratect-compat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ratect-compat"
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
