function mkscript
		echo "#!/bin/bash" > ./$argv
		chmod a+x ./$argv
end
