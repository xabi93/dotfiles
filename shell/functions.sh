function cdd() {
  cd "$(ls -d -- */ | fzf)" || echo "Invalid directory"
}

function recent_dirs() {
  # This script depends on pushd. It works better with autopush enabled in ZSH
  escaped_home=$(echo $HOME | sed 's/\//\\\//g')
  selected=$(dirs -p | sort -u | fzf)

  cd "$(echo "$selected" | sed "s/\~/$escaped_home/")" || echo "Invalid directory"
}

function deploy_local() {
  release_name=$1
  if test -z "$release_name" 
  then
        echo "release name is empty"
        return 1
  fi
  
  echo "release name $release_name"

  image_name=$2
  if test -z "$image_name" 
  then
        echo "image name is empty"
        return 1
  fi
  echo "image name $image_name"

  image_tag=$3
  if test -z "$image_tag" 
  then
        echo "image tag is empty"
        return 1
  fi
  echo "tag name $image_tag"

  environment=$4
  if test -z "$environment" 
  then
        echo "environment is empty"
        return 1
  fi
  echo "environment $environment"

  helm_namespace=$5
  if test -z "$helm_namespace" 
  then
        echo "helm namespace is empty"
        return 1
  fi
  echo "namespace $helm_namespace"
  
  helm dependency update ./deployment/helm

  values='[]'
  if [ -f ./deployment/helm/values.yaml ]; then
    values=$(echo $values | jq '. += ["deployment/helm/values.yaml"]')
  fi
  if [ -f ./deployment/helm/secrets.yaml ]; then
    if ! sops -d -i ./deployment/helm/secrets.yaml; then
      echo "::error file=deployment/helm/secrets.yaml::Error decrypting file"
      return 1
    fi
    values=$(echo $values | jq '. += ["deployment/helm/secrets.yaml"]')
  fi
  if [ -f ./deployment/helm/values.$environment.yaml ]; then
    values=$(echo $values | jq '. += ["deployment/helm/values.'$environment'.yaml"]')
  fi
  if [ -f ./deployment/helm/secrets.$environment.yaml ]; then
    if ! sops -d -i ./deployment/helm/secrets.$environment.yaml; then
      echo "::error file=deployment/helm/secrets.$environment.yaml::Error decrypting file"
      return 1
    fi
    values=$(echo $values | jq '. += ["deployment/helm/secrets.'$environment'.yaml"]')
  fi

  helm upgrade --wait --install --dry-run $release_name deployment/helm  \
    --namespace $helm_namespace \
    --set global.image.name=$image_name \
    --set global.image.tag=$image_tag \
    --set global.environment=$environment \
    $(echo $values | jq -r '.|map_values("--values " + .)|join(" ")')
}
