output "user_arns" {
  value       = module.users[*].arn
  description = "The ARNs of the created IAM users"
}