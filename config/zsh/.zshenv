for file in ~/.config/environment.d/*.conf; do
  if [[ -f "$file" && -r "$file" ]]; then
    source "$file"
  fi
done
