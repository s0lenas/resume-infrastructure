provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "resume-server" {
    ami = "ami-075449515af5df0d1"
    instance_type = "t3.micro"
    user_data = <<EOF
#!/bin/bash
echo "Copying the SSH Key to the server"
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY3Sb7faJaWIbThlXI5l7vMtjEz/hvgTJRBXp7YB7fl4EOfANDyxbfgf9FNbPI3kRWqLAjfNhIqtytuhoDQsEeacUNU6sMVqUupYUACuTOcYh/8ALb8WSiwKy2YEDzjnMoaFdIqI+k0Vw9ObR4Ow3RILUX2gm5y3Ll0XVVpbi1Xb6nNZOTANDTH+mQL7SvtmVuysTO+Zahv2ZzDhfvzx8p+cWXShhwbvgIWNg4aRZ9uq54zcwOKDvHiuqS9aZZmeYp5RgMlGrc6Zp4jSvSkKQiITeN92dtBeGY67D68wb2EQqjCQxB7zPgdqFNIEcIBnwbMY+thVhS0qYhlx7rInIQWw6F6iALlc1A9fuIhk7oFHDDozjoGQM8mej5ET3nkhKA7zoed3khVsskXCiRWUtg8Ijj/G+LFKF5EL1qRIDF4xiEVu9k9InfIP72gxNCjjilB6AbOL7Yo9kK6/cMRecqqclNXnF1DY6Tn+EP8DsXFuf4/occGTccF/H5UBAeHU57ec22Ko6/SZfs/8HKfH4m3z9qQ8tpmdH3Gx6K8n7MgfaPlzAW0hmGA5Bkh5AaLCDb9Z+o2yPn3MsIIH9/gBBHORiQyAVuuT69eMrtnToEpuqV2iS4UTaPnyvMm3W9MmFyi3hZpV/FbPke8Qq4Wz+hPjpnTIiMc2VwAJN1XOrF3w== s0len@DESKTOP-IGSIS6N"
    EOF

    tags = {
        Name = "ResumeServer"
    }
}

resource "aws_route53_zone" "dns-records" {
    name = "herkuskrisciunas.me"
}

resource "aws_route53_record" "www" {
    zone_id = aws_route53_zone.dns-records.zone_id
    name = "herkuskrisciunas.me"
    type = "A"
    ttl = 300
    records = [aws_instance.resume-server.public_ip]
}