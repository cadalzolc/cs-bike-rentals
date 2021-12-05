$(document).on('change', 'input[data-input-radio]', function () {
    var IsCheck = $(this).is(':checked');
    $(this).prop("checked", IsCheck);
    $(this).attr("checked", IsCheck);
    $(this).val(IsCheck);
});

function ToClickLink(elem) {
    window.location.href = $(elem).attr("href");
}

function ReplaceNumberWithCommas(yourNumber) {
    var n = yourNumber.toString().split(".");
    n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return n.join(".");
}

$("#Information").submit(function (event) {
    $("a[data-tab-checkout]").removeClass("text-theme-1");
    $("a[data-tab-checkout]").addClass("text-gray-400 disabled");
    $("#TabShipping").addClass("text-theme-1");
    $("div[data-tab-checkout]").removeClass("in active");
    $("#Payment").addClass("in active");
    var StrAddr = $("#Address").val() + ", " + $("#City").val() + ", " + $("#Province").val() + ", " + $("#Country").val() + " " + $("#Postal_Code").val()
    var StrContact = $("#Mobile").val() + ", " + $("#Email").val();
    var StrName = $("#Name_First").val() + " " + $("#Name_Last").val();
    $("#CloneName").html(StrName);
    $("#CloneContact").html(StrContact);
    $("#CloneShip").html(StrAddr);

    $("#Shiping_Name_First").val($("#Name_First").val());
    $("#Shiping_Name_Last").val($("#Name_Last").val());
    $("#Shiping_Address").val($("#Address").val());
    $("#Shiping_City").val($("#City").val());
    $("#Shiping_State").val($("#Province").val());
    $("#Shiping_Country").val($("#Country").val());
    $("#Shiping_Postal_Code").val($("#Postal_Code").val());
    $("#Shiping_Email").val($("#Email").val());
    $("#Shiping_Mobile").val($("#Mobile").val());
    $("#Subscribe").val($("#Subscribe_Box").val());

    event.preventDefault();
    return false;
});

$(document).on('click', 'a[data-tab-link]', function () {
    $("a[data-tab-checkout]").removeClass("text-theme-1");
    $("a[data-tab-checkout]").addClass("text-gray-400 disabled");
    $("#TabInformation").addClass("text-theme-1");
    $("div[data-tab-checkout]").removeClass("in active");
    $("#Information").addClass("in active");
});

$(document).on('click', 'input[data-mode-payment]', function () {
    var Chd = $(this).data("target");
    $("div[data-payment-child]").removeClass("show");
    $("div[data-payment-child]").addClass("collapsed");
    $("#SpinShip").html("0");

    var ShipTotal = parseFloat($("#SpinTot").data("subtotal"));
    var ShipAmt = parseFloat($(this).data("mode-payment"));
    var AllTotal = ShipTotal + ShipAmt;
    var StrAmt = ReplaceNumberWithCommas(ShipAmt.toFixed(2));
    var StrTotal = ReplaceNumberWithCommas(AllTotal.toFixed(2));

    $("#Mode_Payment").val($(this).data("mode"));
    $("#Shipping_Fee").val(ShipAmt);
    $("#SpinShip").html(StrAmt);
    $("#SpinTot").html(StrTotal);

    $(Chd).removeClass("collapsed");
    $(Chd).addClass("show");
});


$("#FrmCheckoutOrder").submit(function (event) {
    $("#ChkOvLod").addClass("overlay-show");
});

$(document).ready(function () {
    var getActiveSlideIndex = function () {
        return $("#productSlider .active").index("#productSlider .carousel-item");
    };
    var slider = function (IndexNumber) {
        $(".slider .image")
            .removeClass("active")
            .eq(IndexNumber)
            .addClass("active");
    };
    slider(getActiveSlideIndex());
    $("#productSlider").on("slid.bs.carousel", function () {
        slider(getActiveSlideIndex());
    });
});
