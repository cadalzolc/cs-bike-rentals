$(document).on("submit", "form[data-form-modal]", function () {
    var FbnLoader = $(this).data("form-loader");
    var FbnSender = $(this).data("form-sender");
    var FbnReturn = $(this).data("form-return");
    $.ajax({
        type: "POST",
        url: $(this).attr("action"),
        data: $(this).serialize(),
        beforeSend: function () {
            if (FbnLoader) { $(FbnLoader).addClass('overlay-show'); }
            if (FbnSender) { $(FbnSender).attr("disabled", true); }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    if (FbnReturn) {
                        window.location.href = FbnReturn;
                    } else {
                        window.location.reload(true);
                    }
                }, 1200);
            } else {
                toastr.error(data.message);
                if (FbnSender) { $(FbnSender).attr("disabled", false); }
                if (FbnLoader) { $(FbnLoader).removeClass('overlay-show'); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (FbnSender) { $(FbnSender).attr("disabled", false); }
            if (FbnLoader) { $(FbnLoader).removeClass('overlay-show'); }
        }
    });
    return false;
});

function ModaliaClose(MdlContainer) {
    $(MdlContainer).removeClass("fade show");
    $(MdlContainer).hide();
    $(MdlContainer).empty();
}

function ModaliaShow(elem) {
    var MdlContainer = $(elem).data("modalia");
    var MdlLoader = $(elem).data("loader");
    $.ajax({
        type: "GET",
        url: $(elem).data("url"),
        beforeSend: function () {
            if (MdlLoader) {
                $(MdlLoader).addClass('overlay-show');
            }
            $(MdlContainer).empty();
        },
        success: function (data) {
            $(MdlContainer).append(data);
            $(MdlContainer).addClass("fade show");
            $(MdlContainer).show();
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (MdlLoader) {
                $(MdlLoader).removeClass('overlay-show');
            }
        }
    });
}

function ModaliaConfirm(frm) {
    var MdlContainer = $(frm).data("modalia");
    var MdlLoader = $(frm).data("locker");
    $.ajax({
        type: "GET",
        url: $(frm).data("url"),
        beforeSend: function () {
            if (MdlLoader) {
                $(MdlLoader).css('display', 'flex');
            }
            $(MdlContainer).empty();
        },
        success: function (data) {
            if (data.success === true) {
                $(MdlContainer).html(data.result);
                $(MdlContainer).addClass("fade show");
                $(MdlContainer).show();
            } else {
                $(MdlContainer).addClass("fade show");
                $(MdlContainer).hide();
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (MdlLoader) {
                $(MdlLoader).hide();
            }
        }
    });
}

function ModaliaConfirmSubmit(frm) {
    var FbnLoader = $(frm).data("form-loader");
    var FbnModal = $(frm).data("form-modalia");
    var FrmReturn = $(frm).data("form-return");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnLoader) { $(FbnLoader).addClass('overlay-show'); }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    if (FrmReturn) {
                        window.location.href = FrmReturn;
                    } else {
                        window.location.reload(true);
                    }
                }, 1200);
            } else {
                toastr.error(data.message);
                ModaliaClose(FbnModal);
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            ModaliaClose(FbnModal);
        }
    });
    return false;
}

function ModaliaNotice(frm) {
    var MdlLoader = $(frm).data("locker");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (MdlLoader) {
                $(MdlLoader).css('display', 'flex');
            }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
            } else {
                toastr.error(data.message);
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (MdlLoader) {
                $(MdlLoader).hide();
            }
        }
    });
    return false;
}

function FormSubmit(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnCancel = $(frm).data("button-cancel");
    var FbnClose = $(frm).data("button-close");
    var FrmReturn = $(frm).data("return");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            $("#PgBusy").show();
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    if (FrmReturn) {
                        window.location.href = FrmReturn;
                    } else {
                        window.location.reload(true);
                    }
                }, 1500);
            } else {
                toastr.error(data.message);
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnCancel) { $(FbnCancel).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (FbnClose) { $(FbnClose).attr("disabled", false); }
        },
        complete: function () {
            $("#PgBusy").hide();
        }
    });
    return false;
}

function SendRequest(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnCancel = $(frm).data("button-cancel");
    var FbnClose = $(frm).data("button-close");
    var FbnCardReloader = $(frm).data("card-reloader");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            if (FbnCardReloader) {
                $(FbnCardReloader).css('display', 'flex');
            } else {
                $("#PgBusy").show();
            }
        },
        success: function (data) {
            if (data.success === true) {
                $("#DvMsg").empty();
                $("#DvMsg").append(data.result);
                $("#DvMsg").show();
            } else {
                toastr.error(data.message);
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnCancel) { $(FbnCancel).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (FbnClose) { $(FbnClose).attr("disabled", false); }
        },
        complete: function () {
            if (FbnCardReloader) {
                $(FbnCardReloader).hide();
            } else {
                $("#PgBusy").hide();
            }
        }
    });
    return false;
}

function FormReloader(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnCancel = $(frm).data("button-cancel");
    var FbnClose = $(frm).data("button-close");
    var FrmReturn = $(frm).data("return");
    var FbnCardReloader = $(frm).data("loader");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            if (FbnCardReloader) {
                $(FbnCardReloader).addClass('overlay-show');
            }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    if (FrmReturn) {
                        window.location.href = FrmReturn;
                    } else {
                        window.location.reload(true);
                    }
                }, 1500);
            } else {
                toastr.error(data.message);
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnCancel) { $(FbnCancel).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
                if (FbnCardReloader) {
                    $(FbnCardReloader).removeClass('overlay-show');
                }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (FbnClose) { $(FbnClose).attr("disabled", false); }
            if (FbnCardReloader) {
                $(FbnCardReloader).removeClass('overlay-show');
            }
        },
    });
    return false;
}

function FormNoRefresh(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnCancel = $(frm).data("button-cancel");
    var FbnClose = $(frm).data("button-close");
    var FbnCardReloader = $(frm).data("card-reloader");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            $(FbnCardReloader).css('display', 'flex');
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
            } else {
                toastr.error(data.message);
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", false); }
            if (FbnClose) { $(FbnClose).attr("disabled", false); }
            $(FbnCardReloader).hide();
        }
    });
    return false;
}

function FormNoReloading(frm) {
    var FbnModalia= $(frm).data("modalia");
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnCancel = $(frm).data("button-cancel");
    var FbnClose = $(frm).data("button-close");
    var FbnCardReloader = $(frm).data("card-reloader");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            $(FbnCardReloader).css('display', 'flex');
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                if (FbnModalia) {
                    $(FbnModalia).empty();
                    $(FbnModalia).hide();
                }
            } else {
                toastr.error(data.message);
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
            if (FbnCancel) { $(FbnCancel).attr("disabled", false); }
            if (FbnClose) { $(FbnClose).attr("disabled", false); }
            $(FbnCardReloader).hide();
        }
    });
    return false;
}

function LockFormSubmit(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnLocker = $(frm).data("button-locker");
    var FbnClose = $(frm).data("button-close");
    var FbnModal = $(frm).data("button-modal");
    var FbnAuto = $(frm).data("button-auto");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            if (FbnLocker) { $(FbnLocker).addClass('overlay-show'); }
        },
        success: function (data) {
            if (data.success === true) {
                $(FbnModal).empty();
                $(FbnModal).html(data.result);
                $(FbnModal).addClass("show");
                $(FbnModal).show();
                if (FbnAuto) {
                    setTimeout(function () {
                        $(FbnModal).fadeOut(1000, function () {
                            ModaliaClose(FbnModal);
                        });
                    }, 5000);
                }
            } else {
                toastr.error(data.message);
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            $(FbnModal).empty();
            $(FbnModal).removeClass("show");
            $(FbnModal).hide();
        },
        complete: function () {
            if (FbnLocker) {
                if (FbnLocker) { $(FbnLocker).removeClass('overlay-show'); }
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
            }
        }
    });
    return false;
}

function ModaliaLink(elem) {
    var MdlContainer = $(elem).data("modalia");
    var MdlLoader = $(elem).data("locker");
    $.ajax({
        type: "GET",
        url: $(elem).data("url"),
        beforeSend: function () {
            if (MdlLoader) {
                $(MdlLoader).addBack('overlay-show');
            }
            $(MdlContainer).empty();
        },
        success: function (data) {
            $(MdlContainer).append(data);
            $(MdlContainer).addClass("fade show");
            $(MdlContainer).show();
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (MdlLoader) {
                $(MdlLoader).removeClass('overlay-show');
            }
        }
    });
}

function ModaliaSubmit(frm) {
    var FbnConfirm = $(frm).data("button-confirm");
    var FbnLocker = $(frm).data("button-locker");
    var FbnClose = $(frm).data("button-close");
    var FbnAuto = $(frm).data("button-autoclose");
    var FbnRefresh = $(frm).data("button-refresh");
    var FbnModal = $(frm).data("button-modalia");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (FbnConfirm) { $(FbnConfirm).attr("disabled", true); }
            if (FbnClose) { $(FbnClose).attr("disabled", true); }
            if (FbnLocker) { $(FbnLocker).addClass('overlay-show'); }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                if (FbnRefresh) {
                    if (FbnRefresh == true) {
                        window.location.reload();
                    }
                }
                if (FbnAuto) {
                    if (FbnAuto === true) {
                        ModaliaClose(FbnModal);
                    }
                }
            } else {
                toastr.error(data.message);
                if (FbnConfirm) { $(FbnConfirm).attr("disabled", false); }
                if (FbnClose) { $(FbnClose).attr("disabled", false); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            $(FbnModal).empty();
            $(FbnModal).removeClass("show");
            $(FbnModal).hide();
        },
        complete: function () {
            if (FbnLocker) {
                if (FbnLocker) { $(FbnLocker).removeClass('overlay-show'); }
            }
        }
    });
    return false;
}


function ArrCheckerSumbit(elem) {
    var ElemLoader = $(elem).data("checker-loader");
    var ElemChecker = $(elem).data("checker-submit");
    var Arr = $("input[data-checker-owner='" + ElemChecker + "']:checked").map(function () {
        return $(this).data("checker-value");
    }).get();
    var postData = { "Keys": Arr };
    $.ajax({
        type: "POST",
        url: $(elem).data("url"),
        data: postData,
        beforeSend: function () {
            if (ElemLoader) { $(ElemLoader).addClass('overlay-show'); }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    window.location.reload(true);
                }, 1200);
            } else {
                toastr.error(data.message);
                if (ElemLoader) { $(ElemLoader).removeClass('overlay-show'); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (ElemLoader) { $(ElemLoader).removeClass('overlay-show'); }
        }
    });
}

function BasicFormSubmit(frm) {
    var _Loader = $(frm).data("form-loader");
    var _Button = $(frm).data("form-button");
    $.ajax({
        type: "POST",
        url: $(frm).attr("action"),
        data: $(frm).serialize(),
        beforeSend: function () {
            if (_Loader) { $(_Loader).addClass('overlay-show'); }
            if (_Button) { $(_Button).attr("disabled", true); }
        },
        success: function (data) {
            if (data.success === true) {
                toastr.success(data.message);
                setTimeout(function () {
                    window.location.reload(true);
                }, 1200);
            } else {
                toastr.error(data.message);
                if (_Button) { $(_Button).attr("disabled", false); }
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (_Loader) { $(_Loader).removeClass('overlay-show'); }
            if (_Button) { $(_Button).attr("disabled", false); }
        }
    });
    return false;
}

function OnFormModal(Frm) {
    var FrmLoader = $(Frm).data("loader");
    $.ajax({
        type: "POST",
        url: $(Frm).attr("action"),
        data: $(Frm).serialize(),
        beforeSend: function () {
            if (FrmLoader) { $(FrmLoader).addClass('overlay-show'); }
        },
        success: function (data) {       
            FormModalSuccess(data, Frm);
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
            if (FrmLoader) { $(FrmLoader).removeClass('overlay-show'); }
        },
    });
    return false;
}


function FormModalSuccess(data, Frm) {
    var FrmLoader = $(Frm).data("loader");
    var FrmReload = $(Frm).data("reload");
    var FrmReturn = $(Frm).data("return");

    if (data.success === true) {
        toastr.success(data.message);
        if (FrmReload && FrmReload === 1) {
            setTimeout(function () {
                if (FrmReturn) {
                    window.location.href = FrmReturn;
                } else {
                    window.location.reload(true);
                }
            }, 1500);
        } else {
            if (FrmLoader) { $(FrmLoader).removeClass('overlay-show'); }
        }
    } else
    {
        toastr.error(data.message);
        if (FrmLoader) { $(FrmLoader).removeClass('overlay-show'); }
    }
  
    
}

function PopupDialog(elem) {
    var MdlContainer = $(elem).data("modalia");
    var MdlLoader = $(elem).data("loader");
    $.ajax({
        type: "GET",
        url: $(elem).data("url"),
        beforeSend: function () {
            if (MdlLoader) {
                $(MdlLoader).addClass('overlay-show');
            }
            $(MdlContainer).empty();
        },
        success: function (data) {
            if (data.success === true) {
                $(MdlContainer).append(data.result);
                $(MdlContainer).addClass("fade show");
                $(MdlContainer).show();
            } else {
                toastr.error(data.message);
            }
        },
        error: function () {
            toastr.error("Oops! Something went wrong on your request.");
        },
        complete: function () {
            if (MdlLoader) {
                $(MdlLoader).removeClass('overlay-show');
            }
        }
    });
}
