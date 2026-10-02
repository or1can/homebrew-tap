class RatectCompat < Formula
  desc "A strict, flag-for-flag and field-for-field drop-in replacement for the (now-unmaintained) batect binary"
  homepage "https://github.com/or1can/ratect"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.31.0/ratect-compat-aarch64-apple-darwin.tar.xz"
      sha256 "6dd7aa82d0ccc65bfbaf7899cecbcdb03dd52d7eeeb4f2797700bf12aa146cc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.31.0/ratect-compat-x86_64-apple-darwin.tar.xz"
      sha256 "ca1bf70c1e01dd283527476924ccb439ad419704f9ca861100ee7d516cf1cd2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.31.0/ratect-compat-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8c3a18f49af025922dd37c0f8a189f77b7d20ee0703d779ae2f5fe7a409adbed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/or1can/ratect/releases/download/ratect-compat/v0.31.0/ratect-compat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6e9b6de624e0741d9a99ed9311e60343600c6129cfa07863e07f06a1b1f9919c"
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
