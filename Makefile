ra1nstorm.run: $(wildcard stage2/*)
	makeself.sh stage2/ $@ "ra1nstorm_stage2" ./run.sh
