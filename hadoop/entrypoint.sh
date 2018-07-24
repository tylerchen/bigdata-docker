#!/bin/bash

if [ "$STARTUP_SCRIPT" != "" ]; then
  echo '#!/bin/bash' > /initScript.sh
  echo '' >> /initScript.sh
  echo 'cat /initScript.sh' >> /initScript.sh
  echo $STARTUP_SCRIPT | sed 's/,,,/\n/g' >> /initScript.sh
  echo '' >> /initScript.sh

  chmod a+x /initScript.sh
  exec /initScript.sh $@
fi

exec $@
