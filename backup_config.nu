def main [message: string] {
	cp /etc/nixos/configuration.nix configuration.nix;
	git add .; git commit -m $message; git push -u origin main
}
