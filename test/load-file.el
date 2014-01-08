(require 'vbasense)
(require 'el-expectations)

(expectations
  (desc "load-file call load buffer function")
  (expect (mock (vbasense--analyze-file *))
    (let* ((tfile (concat default-directory "sample/ISample.cls"))
           (tliid (vbasense--get-tliid tfile)))
      (remhash tliid vbasense--hash-tli-file-cache)
      (set (intern (concat "vbasense--timer-load-" tliid)) nil)
      (vbasense-load-file tfile)))
  (desc "load-file call timer function")
  (expect (mock (run-with-timer *))
    (let* ((tfile (concat default-directory "sample/ISample.cls")))
      (vbasense-load-file tfile :delay t)))
  (desc "load-file call update availables")
  (expect (mock (vbasense--update-availables *))
    (let* ((tfile (concat default-directory "sample/ISample.cls")))
      (stub vbasense--analyze-file => nil)
      (vbasense-load-file tfile)))
  (desc "load-file not call update availables")
  (expect (not-called vbasense--update-availables)
    (let* ((tfile (concat default-directory "sample/ISample.cls")))
      (stub vbasense--analyze-file => nil)
      (vbasense-load-file tfile :not-update-cache t)))
  (desc "load-file update availables")
  (expect t
    (let* ((tfile (concat default-directory "sample/ISample.cls")))
      (setq vbasense--available-interfaces nil)
      (vbasense-load-file tfile)
      (loop for ifnm in vbasense--available-interfaces
            if (string= ifnm "ISample")
            return t
            finally return nil)))
  )
