 #!/bin/bash
 while IFS='' read -r line || [[ -n "$line" ]]; do
     git clone https://github.com/$line
     done < "$1"
