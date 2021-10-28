app:
	/bin/rm -r -f Danshari.app
	cp bin/danshari .
	platypus --name Danshari --interpreter /usr/bin/ruby --quit-after-execution --droppable --interface-type None --app-icon danshari.icns danshari
