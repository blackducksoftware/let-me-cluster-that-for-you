function push_gke {
	echo "Pushing all images to project wide GKE registry"
	set -x

	# Parse all the images 
	for image in `cat bitbucket/kube/kubernetes-post-db.yml | grep blackducksoftware | cut -d':' -f 2-3 | cut -d'"' -f 2` ; do
		docker pull $image
		docker tag $image  gcr.io/$i
		#docker push gcr.io/gke-verification/$i
		sh ~/google-cloud-sdk/bin/gcloud  docker -- push gcr.io/gke-verification/$i
	done
}

echo "dead code - will use goblin.blackducksoftware.com in the future for images"
