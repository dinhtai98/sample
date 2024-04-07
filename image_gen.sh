# icons_dir="assets/icons"
png_dir="assets/images"
svg_dir="assets/images/svg"
# gifs_dir="assets/gifs"
# json_dir="assets/json"
output="lib/generated_images.dart"
touch "$output"
echo > $output

# if [ "$(ls -A $json_dir)" ]; then
#     echo "class Json {" >> $output
#     for entry in "$json_dir"/*
#         do
#         fname=`basename $entry`
#         name="${fname%%.*}"
#         lowercase=$(echo "$name" | awk '{print tolower($0)}')
#         camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
#         if [[ $camelCase != "2" ]]; then
#         if [[ $camelCase != "3" ]]; then
#         echo "  static const $camelCase = 'packages/$currentPackage/$entry';" >> $output
#         fi
#         fi
#     done
#     echo "}
# " >> $output
# else
#     echo ''
# fi
# if [ "$(ls -A $gifs_dir)" ]; then
#     echo "class Gif {" >> $output
#     for entry in "$gifs_dir"/*
#         do
#         fname=`basename $entry`
#         name="${fname%%.*}"
#         lowercase=$(echo "$name" | awk '{print tolower($0)}')
#         camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
#         if [[ $camelCase != "2" ]]; then
#         if [[ $camelCase != "3" ]]; then
#         echo "  static const $camelCase = 'packages/$currentPackage/$entry';" >> $output
#         fi
#         fi
#     done
#     echo "}
# " >> $output
# else
#     echo ''
# fi
# if [ "$(ls -A $icons_dir)" ]; then
#     echo "class Ic {" >> $output
#     for entry in "$icons_dir"/*
#         do
#         fname=`basename $entry`
#         name="${fname%%.*}"
#         lowercase=$(echo "$name" | awk '{print tolower($0)}')
#         camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
#         if [[ $camelCase != "2" ]]; then
#         if [[ $camelCase != "3" ]]; then
#         echo "  static const $camelCase = 'packages/$currentPackage/$entry';" >> $output
#         fi
#         fi
#     done
#     echo "}
# " >> $output
# else
#     echo ''
# fi
if [ "$(ls -A $png_dir)" ]; then
    echo "class IcPng {" >> $output
    for entry in "$png_dir"/*
        do
        fname=`basename $entry`
        name="${fname%%.*}"
        lowercase=$(echo "$name" | awk '{print tolower($0)}')
        camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
        if [[ $camelCase != "2" ]]; then
        if [[ $camelCase != "3" ]]; then
        echo "  static const $camelCase = '$entry';" >> $output
        fi
        fi
    done
    echo "}
" >> $output
else
    echo ''
fi
if [ "$(ls -A $svg_dir)" ]; then
    echo "class IcSvg {" >> $output
    for entry in "$svg_dir"/*
        do
        fname=`basename $entry`
        name="${fname%%.*}"
        lowercase=$(echo "$name" | awk '{print tolower($0)}')
        camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
        if [[ $camelCase != "2" ]]; then
        if [[ $camelCase != "3" ]]; then
        echo "  static const $camelCase = '$entry';" >> $output
        fi
        fi
    done
    echo "}
" >> $output
else
    echo ''
fi