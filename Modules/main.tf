
module "myvpc" {
  source = "./modules/vpc"

}

module "ansible" {
  source = "./modules/ec2_ansible"
  subnet_id = module.myvpc.subnetpublicid
  securitygroup = module.myvpc.sg_pub_id
}

module "jenkins" {
  source = "./modules/ec2_jenkins"
  subnet_id = module.myvpc.subnetpublicid
  securitygroup = module.myvpc.sg_pub_id
  
}


module "myec2_private" {
  source = "./modules/ec2"
  subnet_id = module.myvpc.subnetprivateid
  securitygroup = module.myvpc.sg_priv_id
}
