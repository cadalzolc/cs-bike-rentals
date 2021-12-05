$(document).on('change', 'input[data-radio-confirm]', function () {
    var ElemTarget = $(this).data("radio-confirm");
    $(ElemTarget).val($(this).data('radio-value') == '1' ? 'true' : 'false');
    $(ElemTarget).prop('checked', $(this).data('radio-value') == '1' ? true : false);
    $(ElemTarget).attr('checked', $(this).data('radio-value') == '1' ? true : false);
});

$(document).on('change', 'input[data-checkbox-self]', function () {
    $(this).val($(this).is(':checked'));
    $(this).prop('checked', $(this).is(':checked'));
    $(this).attr('checked', $(this).is(':checked'));
});

$(document).on('change keyup paste', 'textarea[data-text-editor]', function () {
    var elem = $(this).data("text-editor");
    $(elem).html(this.value.length);
});

$(document).on("click", "[data-show-password]", function () {
    var b = $(this).data("show-password");
    if (b === false) {
        $("input[data-password]").attr("type", "text");
        $("input[data-password]").prop("type", "text");
        $(this).data("show-password", !b);
        $(this).toggleClass("password-true");
    } else {
        $("input[data-password]").attr("type", "password");
        $("input[data-password]").prop("type", "password");
        $(this).data("show-password", !b);
        $(this).toggleClass("password-true");
    }
});

function ToClickLink(elem) {
    window.location.href = $(elem).attr("href");
}

function ReplaceNumberWithCommas(yourNumber) {
    var n = yourNumber.toString().split(".");
    n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return n.join(".");
}

function RoundedNumber(value, decimals) {
    return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals).toFixed(decimals);
}

function formatErrorMessage(jqXHR, exception) {

    if (jqXHR.status === 0) {
        return ('Not connected.\nPlease verify your network connection.');
    } else if (jqXHR.status == 404) {
        return ('The requested page not found. [404]');
    } else if (jqXHR.status == 500) {
        return ('Internal Server Error [500].');
    } else if (exception === 'parsererror') {
        return ('Requested JSON parse failed.');
    } else if (exception === 'timeout') {
        return ('Time out error.');
    } else if (exception === 'abort') {
        return ('Ajax request aborted.');
    } else {
        return ('Uncaught Error.\n' + jqXHR.responseText);
    }
}

function ShowSelectMultiple() {
    var e = document.querySelectorAll('.select-multiple');
    function r(e) {
        if (!e.id || !e.element || !e.element.dataset.avatarSrc) return e.text;
        var t = e.element.dataset.avatarSrc,
            a = document.createElement("div");
        return a.innerHTML = '<span class="avatar avatar-xs mr-3"><img class="avatar-img rounded-circle" src="' + t + '" alt="' + e.text + '"></span><span>' + e.text + "</span>", a
    }
    jQuery().select2 && e && [].forEach.call(e, function (e) {
        var t, a, o, l;
        a = (t = e).dataset.options ? JSON.parse(t.dataset.options) : {}, o = {
            containerCssClass: t.getAttribute("class"),
            dropdownAutoWidth: !0,
            dropdownCssClass: t.classList.contains("custom-select-sm") || t.classList.contains("form-control-sm") ? "dropdown-menu dropdown-menu-sm show" : "dropdown-menu show",
            dropdownParent: t.closest(".modal-body") || document.body,
            templateResult: r,
        },
            l = Object.assign(o, a),
            $(t).select2(l)
    })
}

$.fn.extend({
    qcss: function (css) {
        return $(this).queue(function (next) {
            $(this).css(css);
            next();
        });
    }
});