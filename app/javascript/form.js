// form.js
document.addEventListener("turbo:load", function() {
    // NIE toggles
    const yesRadio     = document.getElementById("needs_nie_yes");
    const noRadio      = document.getElementById("needs_nie_no");
    const nieFields    = document.getElementById("nie_fields");
    const parentFields = document.getElementById("parent_fields");
  
    function toggleNIE() {
      if (yesRadio.checked) {
        parentFields.style.display = "block";
        nieFields.style.display    = "none";
      } else {
        parentFields.style.display = "none";
        nieFields.style.display    = "block";
      }
    }
    yesRadio?.addEventListener("change", toggleNIE);
    noRadio?.addEventListener("change", toggleNIE);
    toggleNIE();
  
    // Bank “same account” sync
    const payYes       = document.getElementById("pay_res_yes");
    const payNo        = document.getElementById("pay_res_no");
    const resContainer = document.getElementById("reservation_container");
    const sameCB       = document.getElementById("use_same_account");
    const reservation  = document.getElementById("reservation_bank");
    const contract     = document.getElementById("contract_bank");
    const balance      = document.getElementById("balance_bank");
  
    function toggleReservation() {
      resContainer.style.display = payYes.checked ? "block" : "none";
      syncBank();
    }
    function syncBank() {
      const master = (resContainer.style.display === "block")
                     ? reservation
                     : contract;
      if (sameCB.checked) {
        contract.value    = master.value;
        balance.value     = master.value;
        contract.readOnly = true;
        balance.readOnly  = true;
      } else {
        contract.readOnly = false;
        balance.readOnly  = false;
      }
    }
    payYes?.addEventListener("change",  toggleReservation);
    payNo?.addEventListener("change",   toggleReservation);
    sameCB?.addEventListener("change",  syncBank);
    reservation?.addEventListener("input", syncBank);
    contract?.addEventListener("input",    syncBank);
    toggleReservation();
  });
  