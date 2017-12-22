/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtCore/QLibraryInfo>
#include <QtWidgets/QApplication>
#include <QtWidgets/QAction>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QMessageBox>

#include "mainwindow.h"

// ![0]


MainWindow::MainWindow()
{
    createActions();
    createMenus();

    setWindowTitle(tr("Simple Text Viewer"));
    resize(750, 400);
}
//! [1]


//! [4]
void MainWindow::createActions()
{
    newAct = new QAction(tr("&New"), this);
    newAct->setShortcuts(QKeySequence::New);
    connect(newAct, &QAction::triggered, this, &MainWindow::newFile);

    openAct = new QAction(tr("&Open"), this);
    openAct->setShortcuts(QKeySequence::Open);
    connect(openAct, &QAction::triggered, this, &MainWindow::dummySlot);

    saveAct = new QAction(tr("&Save"), this);
    saveAct->setShortcuts(QKeySequence::Save);
    connect(saveAct, &QAction::triggered, this, &MainWindow::dummySlot);

    saveAsAct = new QAction(tr("Save &As"), this);
    saveAsAct->setShortcuts(QKeySequence::SaveAs);
    connect(saveAsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    exitAct = new QAction(tr("E&xit"), this);
    exitAct->setShortcuts(QKeySequence::Quit);
    connect(exitAct, SIGNAL(triggered()), this, SLOT(close()));

    wellsAct = new QAction(tr("Edit &Wells"), this);
    connect(wellsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    pumpingRatesAct = new QAction(tr("Edit &Pumping Rates"), this);
    connect(pumpingRatesAct, &QAction::triggered, this, &MainWindow::dummySlot);

    aquiferDrawdownAct = new QAction(tr("&Aquifer Drawdown"), this);
    connect(aquiferDrawdownAct, &QAction::triggered, this, &MainWindow::dummySlot);

    wellLossAct = new QAction(tr("Well &Loss"), this);
    connect(wellLossAct, &QAction::triggered, this, &MainWindow::dummySlot);

    runModelAct = new QAction(tr("&Run"), this);
    connect(runModelAct, &QAction::triggered, this, &MainWindow::dummySlot);

    pestSettingsAct = new QAction(tr("&Settings"), this);
    connect(pestSettingsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    observedHeadAct = new QAction(tr("Observed &Heads"), this);
    connect(observedHeadAct, &QAction::triggered, this, &MainWindow::dummySlot);

    windowsAct = new QAction(tr("&Windows"), this);
    connect(windowsAct, &QAction::triggered, this, &MainWindow::dummySlot);

    runPestAct = new QAction(tr("&Run"), this);
    connect(runPestAct, &QAction::triggered, this, &MainWindow::dummySlot);
}


void MainWindow::createMenus()
{
    fileMenu = new QMenu(tr("&File"), this);
    fileMenu->addAction(newAct);
    fileMenu->addAction(openAct);
    fileMenu->addAction(saveAct);
    fileMenu->addAction(saveAsAct);
    fileMenu->addAction(exitAct);
    menuBar()->addMenu(fileMenu);

    modelMenu = new QMenu(tr("&Model"), this);
    modelMenu->addAction(wellsAct);
    modelMenu->addAction(pumpingRatesAct);
    modelMenu->addAction(aquiferDrawdownAct);
    modelMenu->addAction(wellLossAct);
    modelMenu->addSeparator();
    modelMenu->addAction(runModelAct);
    menuBar()->addMenu(modelMenu);

    pestMenu = new QMenu(tr("&PEST"), this);
    pestMenu->addAction(pestSettingsAct);
    pestMenu->addAction(observedHeadAct);
    pestMenu->addAction(windowsAct);
    pestMenu->addSeparator();
    pestMenu->addAction(runPestAct);
    menuBar()->addMenu(pestMenu);
}

void MainWindow::newFile()
{
    return;
}

void MainWindow::dummySlot()
{
    return;
}
