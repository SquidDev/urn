(import urn/logger logger)

(defun include-rocks (logger paths)
  "Include all installed rocks into the PATHS list."
  (if-with ((ok cfg) (pcall require "luarocks.core.cfg"))
    (progn
      ;; LuaRocks 3
      (call cfg :init_package_paths)
      (include-rocks-impl logger paths
        cfg
        (require "luarocks.core.path")
        (require "luarocks.core.manif")
        (require "luarocks.core.vers")
        (require "luarocks.core.util")
        (require "luarocks.dir")))

    (if-with ((ok cfg) (pcall require "luarocks.cfg"))
      (progn
        ;; LuaRocks 2
        (call cfg :init_package_paths)
        (include-rocks-impl logger paths
          cfg
          (require "luarocks.path")
          (require "luarocks.manif_core")
          (require "luarocks.deps")
          (require "luarocks.util")
          (require "luarocks.dir")))

      nil?)))

(defun include-rocks-impl (logger paths cfg path manif vers util dir)
  :hidden
  (for-each tree (struct->list (.> cfg :rocks_trees))
    (let* [(rocks-dir (call path :rocks_dir tree))
           (manifest (call manif :load_local_manifest rocks-dir))]

      (for-pairs (module versions) (.> manifest :repository)
        ;; Skip modules with no versions and explicitly blacklist Urn to avoid
        ;; duplicating the standard library.
        (unless (or (empty-struct? versions) (= module "urn"))
          ;; Find the latest version and use that. This is what luarocks.loader does,
          ;; so it's sort of acceptable.
          (let* [(main-version (-> (keys versions)
                                   (map (.> vers :parse_version) <>)
                                   (apply math/min <>)
                                   (.> <> :string)))
                 (root-path (call path :install_dir module main-version tree))]

            ;; Push X/urn-lib/? and X/urn-lib/?/init onto the path
            (logger/put-verbose! logger (string/format "Including %s %s (located at %s)" module main-version root-path))
            (push! paths (call dir :path root-path "urn-lib" "?"))
            (push! paths (call dir :path root-path "urn-lib" "?" "init"))))))))
