#! /bin/bash

function assert_var_not_null() {
  local fatal var num_null=0
  for var in "$@"; do
    [[ -z "${!var}" ]] &&
      printf '%s\n' "Environment variable '$var' not set" >&2 &&
      ((num_null++))
  done

  if ((num_null > 0)); then
    exit 1
  fi
  return 0
}

assert_var_not_null AZURE_TENANT_ID
assert_var_not_null AZURE_TENANT_PASS
assert_var_not_null AZURE_TENANT
assert_var_not_null AKS_CLUSTER_NAME
assert_var_not_null AKS_RESOURCE_GROUP 
assert_var_not_null AKS_SERVICE_NAME
