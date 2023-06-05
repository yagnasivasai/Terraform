module "myvpc" {
  source = "./modules/vpc"

}

module "webserver" {
  source        = "./modules/webserver"
  subnet_id     = module.myvpc.subnetpublicid
  securitygroup = module.myvpc.webserver_sg
}

module "datastore" {
  source        = "./modules/datastore"
  subnet_id     = module.myvpc.subnetprivateid
  securitygroup = module.myvpc.datastore

}


module "webdata_agent" {
  source        = "./modules/webdata_agent"
  subnet_id     = module.myvpc.subnetprivateid
  securitygroup = module.myvpc.webdata_agent
}

module "services_analytics" {
  source        = "./modules/services_analytics"
  subnet_id     = module.myvpc.subnetprivateid
  securitygroup = module.myvpc.webservices_analytics
}
