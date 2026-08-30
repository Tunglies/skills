#!/usr/bin/env bash

set -euo pipefail

repo_root=$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

mode='link'
dry_run=0
skill_name=
target_root=${CODEX_HOME:-${HOME:?HOME must be set}/.codex}/skills

usage() {
  cat <<'EOF'
Usage: ./install-local.sh [options] <skill-name>

Install or replace a skill from this repository.

Options:
  --link              Link the repository skill into the target (default).
  --copy              Install an independent copy of the skill.
  --target-root DIR   Skill root (default: ${CODEX_HOME:-$HOME/.codex}/skills).
  --dry-run           Print the planned changes without modifying files.
  -h, --help          Show this help.

Existing destinations are moved to <target-root>.backups before replacement.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

path_exists() {
  [[ -e $1 || -L $1 ]]
}

next_backup_path() {
  local backup_root=$1
  local name=$2
  local timestamp candidate suffix

  timestamp=$(date '+%Y%m%d-%H%M%S')
  candidate="$backup_root/$name-$timestamp"
  suffix=1
  while path_exists "$candidate"; do
    candidate="$backup_root/$name-$timestamp-$suffix"
    suffix=$((suffix + 1))
  done
  printf '%s\n' "$candidate"
}

while (($# > 0)); do
  case $1 in
    --link)
      mode='link'
      ;;
    --copy)
      mode='copy'
      ;;
    --target-root)
      shift
      (($# > 0)) || die '--target-root requires a directory'
      target_root=$1
      ;;
    --dry-run)
      dry_run=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      [[ -z $skill_name ]] || die 'exactly one skill name is required'
      skill_name=$1
      ;;
  esac
  shift
done

if (($# > 0)); then
  [[ -z $skill_name ]] || die 'exactly one skill name is required'
  skill_name=$1
  shift
fi
(($# == 0)) || die 'exactly one skill name is required'

[[ -n $skill_name ]] || die 'a skill name is required'
[[ $skill_name =~ ^[a-z0-9][a-z0-9-]*$ ]] || die "invalid skill name: $skill_name"
[[ -n $target_root && $target_root != / ]] || die 'target root must not be empty or /'

source_dir="$repo_root/$skill_name"
destination="$target_root/$skill_name"
backup_root="${target_root}.backups"

[[ -d $source_dir && -f $source_dir/SKILL.md ]] ||
  die "repository skill not found: $source_dir"

if [[ -d $destination ]]; then
  resolved_destination=$(CDPATH='' cd -- "$destination" && pwd -P)
  if [[ $resolved_destination == "$source_dir" ]]; then
    if [[ $mode == link && -L $destination ]]; then
      printf 'Already linked: %s -> %s\n' "$destination" "$source_dir"
      exit 0
    fi
    [[ -L $destination ]] || die 'target resolves to the repository source directory'
  fi
fi

backup_path=
if path_exists "$destination"; then
  backup_path=$(next_backup_path "$backup_root" "$skill_name")
fi

if ((dry_run)); then
  [[ -z $backup_path ]] || printf 'Would move: %s -> %s\n' "$destination" "$backup_path"
  if [[ $mode == link ]]; then
    printf 'Would link: %s -> %s\n' "$destination" "$source_dir"
  else
    printf 'Would copy: %s -> %s\n' "$source_dir" "$destination"
  fi
  exit 0
fi

mkdir -p "$target_root"
staging_dir=$(mktemp -d "$target_root/.${skill_name}.install.XXXXXX")
staged_skill="$staging_dir/$skill_name"
cleanup_staging() {
  if [[ -n ${staging_dir:-} && -d $staging_dir ]]; then
    rm -rf "$staging_dir"
  fi
}
trap cleanup_staging EXIT

if [[ $mode == link ]]; then
  ln -s "$source_dir" "$staged_skill"
else
  mkdir "$staged_skill"
  cp -R "$source_dir/." "$staged_skill/"
fi

if [[ -n $backup_path ]]; then
  mkdir -p "$backup_root"
  mv "$destination" "$backup_path"
fi

restore_backup() {
  if [[ -n $backup_path ]] && ! path_exists "$destination" && path_exists "$backup_path"; then
    mv "$backup_path" "$destination"
  fi
}

if ! mv "$staged_skill" "$destination"; then
  restore_backup
  die "failed to install skill: $skill_name"
fi
rmdir "$staging_dir"
staging_dir=

printf 'Installed (%s): %s -> %s\n' "$mode" "$source_dir" "$destination"
[[ -z $backup_path ]] || printf 'Previous installation: %s\n' "$backup_path"
