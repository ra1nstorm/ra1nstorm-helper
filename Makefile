setup.exe: stage1/main.iss ra1nstorm.run
	cd stage1; ../util/iscc $$(winepath -w $$PWD/main.iss)

ra1nstorm.run: $(wildcard stage2/*)
	makeself.sh stage2/ $@ "ra1nstorm_stage2" ./run.sh
