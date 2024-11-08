;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; (setq doom-theme 'solarized-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Keybindings from Org Manual
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;;To scan the org directory for dates and tags
(after! org
  (setq org-directory "~/Documents/org/")
  (setq org-agenda-files (list org-directory))
  (setq org-agenda-dim-blocked-tasks t)
  )

;; Roam Directory
(setq org-roam-directory "~/Documents/org/roam/")

;; Citar
(setq! citar-bibliography '("/Users/benano/Documents/org/zotlib.bib"))
(setq! citar-notes-paths '("/Users/benano/Documents/org/notes/"))
(setq! citar-symbol-separator "  ")

(defun my-org-journal-date-format (date)
  "Custom function to format the date and add sections."
  (concat
   (format-time-string "* %A, %x" date) "\n"))

;;    "** Journal\n"
;;    "** Work\n"
;;    "** Learning\n"))

(after! org-journal
  (setq org-journal-dir "/Users/benano/Documents/org/journal"
        org-journal-file-format "%Y%m%d.org"
        org-journal-file-type 'weekly
        org-journal-date-format #'my-org-journal-date-format
        org-journal-date-prefix "* "
        org-journal-time-prefix ""
        org-journal-carryover-items nil
        org-journal-created-property-timestamp-format "%Y%m%d"))


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Bibtex
(use-package org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq orb-preformat-keywords
        '("citekey" "title" "url" "author-or-editor" "keywords" "file")
        orb-process-file-keyword t
        orb-attached-file-extensions '("pdf")))

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Bibtex
(use-package org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq orb-preformat-keywords
        '("citekey" "title" "url" "author-or-editor" "keywords" "file")
        orb-process-file-keyword t
        orb-attached-file-extensions '("pdf")))

;; Citar
(use-package citar
  :after org
  :config
  (setq! citar-bibliography '("/Users/benano/Documents/org/zotlib.bib"))
  (setq! citar-notes-paths '("/Users/benano/Documents/org/notes/"))

  (setq citar-templates
      '((main . "${author editor:30%sn}     ${date year issued:4}     ${title:48}")
        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
        (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
        (note . "Notes on ${author editor:%etal}, ${title}")))
  (setq citar-symbols
        `((file ,(nerd-icons-faicon "nf-fa-file_o" :face 'nerd-icons-green) . " ")
          (note ,(nerd-icons-mdicon "nf-md-note" :face 'nerd-icons-blue) . " ")
          (link ,(nerd-icons-octicon "nf-oct-link" :face 'nerd-icons-orange) . " "))))

;; Roam Ui
(use-package! websocket
    :after org-roam)

(setq copilot-node-executable "/Users/benano/.nvm/versions/node/v22.11.0/bin/node")
;; (setq org-latex-create-formula-image-program 'dvisvgm)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


;; Viewing PDFs
(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\'"
  :bind (:map pdf-view-mode-map
         ("j" . pdf-view-next-line-or-next-page)
         ("k" . pdf-view-previous-line-or-previous-page)
         ("l" . image-forward-hscroll)
         ("h" . image-backward-hscroll)
         ("G" . pdf-view-last-page)
         ("q" . quit-window))
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf'")
  :hook (pdf-view-mode . (lambda () (display-line-numbers-mode -1))))


;; Viewing pdfs from latex
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;; Adding Latex previewing
(defun add-org-latex-preview-startup ()
  "Add #+STARTUP: latexpreview to the beginning of org files if not present."
  (when (and (eq major-mode 'org-mode)
             (not (string-match "^#\\+STARTUP:.*latexpreview" (buffer-string))))
    (save-excursion
      (goto-char (point-min))
      (insert "#+STARTUP: latexpreview\n\n"))))

(add-hook 'find-file-hook 'add-org-latex-preview-startup)

;; Setting up pyright
(setq python-shell-interpreter "python")
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :config
  (setq lsp-pyright-use-workspace-root t)
  (setq lsp-pyright-venv-path (getenv "CONDA_PREFIX")))
