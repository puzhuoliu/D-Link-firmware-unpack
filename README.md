# D-Link-firmware-unpack
The firmware starts with `encrpted_img` or `shrs` bytes. Please note that to protect the company's intellectual property, the key is replaced by `XXX`.

<br/>

<br/>


##  ***Started with `encrpted_img` firmware unpack***

`./encrpted_de firmware save_bin`

The save_bin is UBI file. We use [ubi_reader](https://github.com/jrspruitt/ubi_reader) for further processsing.


`./ubi_reader-master/scripts/ubireader_extract_images save_bin -o image`

Then, we use binwalk to extract the image.

`binwalk -Me image`


<br/>

<br/>


##  ***Started with `shrs` firmware unpack***

`python3 shrs_de -i firmware -o image`

Then, we use binwalk to extract the image.

`binwalk -Me image`
