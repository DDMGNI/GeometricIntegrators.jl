
@testset "$(rpad("Special Partitioned Additive Runge-Kutta Tableaus",80))" begin

    @test typeof(TableauSPARKGLRK(1))                 <: TableauSPARK
    @test typeof(TableauSPARKGLRK(2))                 <: TableauSPARK
    @test typeof(TableauSPARKLobIIIAIIIB(2))          <: TableauSPARK
    @test typeof(TableauSPARKLobIIIAIIIB(3))          <: TableauSPARK
    @test typeof(TableauSPARKGLRKLobIIIAIIIB(1))      <: TableauSPARK
    @test typeof(TableauSPARKGLRKLobIIIAIIIB(2))      <: TableauSPARK
    @test typeof(TableauSPARKLobABC(2))               <: TableauSPARK
    @test typeof(TableauSPARKLobABC(3))               <: TableauSPARK
    @test typeof(TableauSPARKLobABD(2))               <: TableauSPARK
    @test typeof(TableauSPARKLobABD(3))               <: TableauSPARK
    @test typeof(TableauSPARKGLVPRK(1))               <: TableauSPARK
    @test typeof(TableauSPARKGLVPRK(2))               <: TableauSPARK

    @test typeof(TableauGLRKpSymplectic(1))           <: TableauVPARK
    @test typeof(TableauGLRKpSymplectic(2))           <: TableauVPARK
    @test typeof(TableauLobIIIAIIIBpSymplectic(2))    <: TableauVPARK
    @test typeof(TableauLobIIIAIIIBpSymplectic(3))    <: TableauVPARK
    @test typeof(TableauLobIIIAIIIBpSymplectic(4))    <: TableauVPARK
    @test typeof(TableauLobIIIBIIIApSymplectic(2))    <: TableauVPARK
    @test typeof(TableauLobIIIBIIIApSymplectic(3))    <: TableauVPARK
    @test typeof(TableauLobIIIBIIIApSymplectic(4))    <: TableauVPARK

    @test typeof(TableauVSPARKGLRKpLobIIIAIIIB(1))                 <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpLobIIIAIIIB(2))                 <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpLobIIIBIIIA(1))                 <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpLobIIIBIIIA(2))                 <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedLobIIIAIIIB(1))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedLobIIIAIIIB(2))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedLobIIIBIIIA(1))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedLobIIIBIIIA(2))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpInternal(1))                    <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpInternal(2))                    <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedInternal(1))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedInternal(2))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpMidpoint(1))                    <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpMidpoint(2))                    <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedMidpoint(1))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpModifiedMidpoint(2))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpSymmetric(1))                   <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpSymmetric(2))                   <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpSymplectic(1))                  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKGLRKpSymplectic(2))                  <: TableauVSPARKprimary

    @test typeof(TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(3))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApLobIIIAIIIB(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApLobIIIAIIIB(3))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(3))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApLobIIIBIIIA(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApLobIIIBIIIA(3))          <: TableauVSPARKprimary

    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(2))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(3))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(2))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(3))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(2))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(3))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(2))  <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(3))  <: TableauVSPARKprimary

    @test typeof(TableauVSPARKLobIIIAIIIBpMidpoint(2))             <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpMidpoint(3))             <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApMidpoint(2))             <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApMidpoint(3))             <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedMidpoint(2))     <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpModifiedMidpoint(3))     <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedMidpoint(2))     <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApModifiedMidpoint(3))     <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpSymmetric(2))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIAIIIBpSymmetric(3))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApSymmetric(2))            <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobIIIBIIIApSymmetric(3))            <: TableauVSPARKprimary

    @test typeof(TableauVSPARKLobABCCD(2))        <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobABCCE(2))        <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobABDE(2))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobABED(2))         <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobABD(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobABE(2))          <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobDE(2))           <: TableauVSPARKprimary
    @test typeof(TableauVSPARKLobED(2))           <: TableauVSPARKprimary

    @test typeof(TableauVSPARKLobIIIAB(2))        <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKLobIIIBA(2))        <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKLobIIIC(2))         <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKLobIIID(2))         <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKLobIIIE(2))         <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKGLRKLobIIIAB(2))    <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKGLRKLobIIIBA(2))    <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKGLRKLobIIIC(2))     <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKGLRKLobIIID(2))     <: TableauVSPARKsecondary
    @test typeof(TableauVSPARKGLRKLobIIIE(2))     <: TableauVSPARKsecondary

    @test typeof(TableauHPARKGLRK(1))             <: TableauHPARK
    @test typeof(TableauHPARKGLRK(2))             <: TableauHPARK
    @test typeof(TableauHPARKLobIIIAIIIB(2))      <: TableauHPARK
    @test typeof(TableauHPARKLobIIIAIIIB(3))      <: TableauHPARK
    @test typeof(TableauHPARKLobIIIBIIIA(2))      <: TableauHPARK
    @test typeof(TableauHPARKLobIIIBIIIA(3))      <: TableauHPARK

    @test typeof(TableauHSPARKGLRKpSymmetric(1))                   <: TableauHSPARKprimary
    @test typeof(TableauHSPARKGLRKpSymmetric(2))                   <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIAIIIBpSymmetric(2))            <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIAIIIBpSymmetric(3))            <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIAIIIBpSymmetric(4))            <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIBIIIApSymmetric(2))            <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIBIIIApSymmetric(3))            <: TableauHSPARKprimary
    @test typeof(TableauHSPARKLobIIIBIIIApSymmetric(4))            <: TableauHSPARKprimary

    @test typeof(TableauHSPARKLobIIIAB(2))                         <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKLobIIIBA(2))                         <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKLobIIIC(2))                          <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKLobIIID(2))                          <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKLobIIIE(2))                          <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKGLRKLobIIIAB(1))                     <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKGLRKLobIIIBA(1))                     <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKGLRKLobIIIC(1))                      <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKGLRKLobIIID(1))                      <: TableauHSPARKsecondary
    @test typeof(TableauHSPARKGLRKLobIIIE(1))                      <: TableauHSPARKsecondary

    @test typeof(getTableauSLRKLobIIIAB(2)) <: TableauSLRK
    @test typeof(getTableauSLRKLobIIIC(2))  <: TableauSLRK
    @test typeof(getTableauSLRKLobIIID(2))  <: TableauSLRK
    @test typeof(getTableauSLRKLobIIIE(2))  <: TableauSLRK

end
