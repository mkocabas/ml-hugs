#
# For licensing see accompanying LICENSE file.
# Copyright (C) 2024 Apple Inc. All Rights Reserved.
#

#!/bin/bash

# download neuman data
wget https://docs-assets.developer.apple.com/ml-research/models/hugs/neuman_data.zip

# download pretrained models 
wget https://docs-assets.developer.apple.com/ml-research/models/hugs/hugs_pretrained_models.zip

unzip -qq neuman_data.zip
unzip -qq hugs_pretrained_models.zip

rm neuman_data.zip
rm hugs_pretrained_models.zip

# download SMPL models
mkdir data/smpl
curl 'https://download.is.tue.mpg.de/download.php?domain=smpl&sfile=SMPL_python_v.1.1.0.zip' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Referer: https://smpl.is.tue.mpg.de/' -H 'Cookie: rl_anonymous_id=%22620ad91f-062a-4c18-8590-be1ca626f199%22; rl_user_id=%22%22; PHPSESSID=det9mp92tddoha1iv5fuss5753' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-site' -H 'Sec-Fetch-User: ?1' --output data/smpl/SMPL_NEUTRAL.pkl

curl 'https://download.is.tue.mpg.de/download.php?domain=smpl&sfile=smpl_uv_20200910.zip' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Referer: https://smpl.is.tue.mpg.de/' -H 'Cookie: rl_anonymous_id=%22620ad91f-062a-4c18-8590-be1ca626f199%22; rl_user_id=%22%22; PHPSESSID=det9mp92tddoha1iv5fuss5753' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-site' -H 'Sec-Fetch-User: ?1' --output data/smpl/smpl_uv.zip

cd data/smpl
unzip smpl_uv.zip


# download AMASS mocap sequences
cd ../
curl 'https://download.is.tue.mpg.de/download.php?domain=amass&resume=1&sfile=amass_per_dataset/smplh/gender_specific/mosh_results/MoSh.tar.bz2' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Referer: https://amass.is.tue.mpg.de/' -H 'Cookie: rl_anonymous_id=%22620ad91f-062a-4c18-8590-be1ca626f199%22; rl_user_id=%22%22; PHPSESSID=det9mp92tddoha1iv5fuss5753' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-site' -H 'Sec-Fetch-User: ?1' --output MoSh.tar.bz2

curl 'https://download.is.tue.mpg.de/download.php?domain=amass&resume=1&sfile=amass_per_dataset/smplh/gender_specific/mosh_results/SFU.tar.bz2' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Referer: https://amass.is.tue.mpg.de/' -H 'Cookie: rl_anonymous_id=%22620ad91f-062a-4c18-8590-be1ca626f199%22; rl_user_id=%22%22; PHPSESSID=det9mp92tddoha1iv5fuss5753' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-site' -H 'Sec-Fetch-User: ?1' --output SFU.tar.bz2

tar -xvf MoSh.tar.bz2
tar -xvf SFU.tar.bz2

rm MoSh.tar.bz2
rm SFU.tar.bz2