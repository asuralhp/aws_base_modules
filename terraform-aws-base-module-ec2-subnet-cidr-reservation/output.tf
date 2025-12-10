output "aws_ec2_subnet_cidr_reservation" {
  description = "All attributes from the created EC2 Subnet CIDR Reservation resource."
  value       = aws_ec2_subnet_cidr_reservation.this
}

output "aws_ec2_subnet_cidr_reservation_id" {
  description = "ID of the created EC2 Subnet CIDR Reservation."
  value       = aws_ec2_subnet_cidr_reservation.this.id
}
