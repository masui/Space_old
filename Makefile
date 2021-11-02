# brew install platypus
# brew install poppler (pdftopngのため)

.PHONY: world danshari

world:
	/bin/rm -r -f World.app
	cp bin/world .
	platypus --name World --interpreter /usr/bin/ruby --quit-after-execution --droppable --interface-type None --app-icon world.icns world
	mv World.app masui-world.app

danshari:
	/bin/rm -r -f Danshari.app
	cp bin/danshari .
	platypus --name Danshari --interpreter /usr/bin/ruby --quit-after-execution --droppable --interface-type None --app-icon danshari.icns danshari

#	platypus --name Danshari --interpreter /usr/bin/ruby --droppable --interface-type 'Text Window' --app-icon danshari.icns danshari
